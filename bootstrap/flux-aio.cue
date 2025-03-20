bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-aio"
	instances: {
		"flux-system": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-git-sync"
			namespace: "flux-system"
			values: {
				git: {
					token:  string @timoni(runtime:string:GITHUB_TOKEN)
					url:    "https://github.com/mkenkel/homelab.git"
					ref:    "refs/heads/main"
					path:   "clusters/k8s"
					ignore: "clusters/**/flux-system/"
				}
				sync: wait: false
			}
		}
		"cilium": {
			module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
			namespace: "flux-system"
			values: {
				repository: url: "https://helm.cilium.io"
				chart: {
					name:    "cilium"
					version: "*"
				}
				helmValues: {
					operator: replicas: 1
					ipam: mode:         "kubernetes"
				}
				sync: targetNamespace: "kube-system"
			}
		}
	}
}
