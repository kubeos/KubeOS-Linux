# Licences and third-party components

KubeOS is free software. This page lists what KubeOS ships, under which licence, and where to
obtain the corresponding source. It is the reference for the project itself; the same information
is delivered with the product, because a notice nobody can read is not a notice:

| Where | What |
|---|---|
| `LICENSE`, `NOTICE` (this repository) | KubeOS's own licence (Apache-2.0) and attribution |
| `/usr/share/doc/kubeos-control-plane/` **in the ISO** | NOTICE + `LICENSE.kubernetes` + `LICENSE.etcd` for the vendored control-plane binaries |
| `/usr/share/doc/*/copyright` **in the ISO** | every Debian package's own licence and copyright |
| `/usr/share/doc/kubeos-dashboard/` **on each node** | the dashboard's `LICENSE`, `NOTICE` and `LICENSE.headlamp`, installed by the dashboard installer |

---

## 1. KubeOS itself — Apache License 2.0

The KubeOS distribution, its build configuration, the first-boot logic, the helper commands and
the KubeOS dashboard are licensed under the **Apache License, Version 2.0**. The full text is in
[`LICENSE`](../LICENSE); attribution is in [`NOTICE`](../NOTICE).

You may use, modify and redistribute them, including commercially, provided you keep the licence
and notices and state what you changed. There is no warranty.

Source: <https://github.com/skmdab/KubeOS> (ISO) and <https://github.com/skmdab/kubeos-dashboard>
(dashboard).

---

## 2. Components redistributed inside the ISO

| Component | Licence | Source |
|---|---|---|
| Debian 13 "trixie" packages (the base system, kernel, firmware, containerd, helm, …) | per package — GPL-2.0/3.0, LGPL, Apache-2.0, MIT, BSD and others | <https://deb.debian.org/debian/>; each package's copyright file is in the image under `/usr/share/doc/<package>/copyright` |
| `kubelet`, `kubeadm`, `kubectl`, `kubernetes-cni` (and the optional `cri-tools`) | Apache-2.0 | the upstream Debian packages from <https://pkgs.k8s.io/core:/stable:/> at the version named by `kubeos-kubernetes`, redistributed **byte-identical** through <https://repo.kubeos.in/>; copyright files ship inside each package |
| `kube-apiserver`, `kube-controller-manager`, `kube-scheduler`, `kube-proxy` (vendored release binaries) | Apache-2.0 | <https://github.com/kubernetes/kubernetes> at the version pinned in the build hook |
| `etcd`, `etcdctl` (vendored release binaries) | Apache-2.0 | <https://github.com/etcd-io/etcd> |
| `registry.k8s.io/pause` image (the pod sandbox, imported into the image's container store) | Apache-2.0 | <https://github.com/kubernetes/kubernetes/tree/master/build/pause> |
| KubeOS dashboard: Headlamp server binary + frontend | Apache-2.0 | <https://github.com/kubernetes-sigs/headlamp> |

The KubeOS-specific manifests that run as **host services** (DNS, metrics, storage provisioner,
proxy) are this project's own work and need no third-party notice.

---

## 3. Source availability (GPL and LGPL components)

The ISO redistributes GPL- and LGPL-licensed binaries as part of the Debian base system. KubeOS
ships **binary images only** (`--source false` in `auto/config`), so the corresponding source is
made available by the following means, which satisfy the GPL's requirement to accompany the
binaries with source or with an equivalent way to get it:

1. **Debian packages.** The complete corresponding source of every Debian package is available
   free of charge from the Debian archive the image was built from
   (<https://deb.debian.org/debian/>, release `trixie`, including `main`, `contrib` and
   `non-free-firmware`). It can be downloaded per package with
   `apt-get source <package>` on any Debian 13 system, or browsed at
   <https://sources.debian.org/>. The exact versions installed in a given image are those in
   `/usr/share/doc/*/changelog.Debian.gz` and `dpkg -l` on that system.
2. **Kubernetes packages (`kubelet`, `kubeadm`, `kubectl`, `kubernetes-cni`, `cri-tools`).**
   The binaries are unmodified upstream packages, redistributed through
   <https://repo.kubeos.in/>; their source is published by the Kubernetes project at
   <https://github.com/kubernetes/kubernetes> and
   <https://github.com/kubernetes-sigs/cri-tools> under the same version tag.
3. **Written offer.** If you received an ISO and the sources above are not sufficient for your
   situation, contact the maintainer at the address below and the corresponding source will be
   provided for at least three years from the date the image was distributed.

> **Maintainer contact for source requests:** `TODO: add a real address before publishing`
> (for example `source@kubeos.in` or the repository's issue tracker).

KubeOS's own source is public, so nothing is withheld; this section exists only so the obligation
is stated in the product, not just implied.

---

## 4. Trademarks and affiliation

"KubeOS" and the KubeOS marks identify this distribution only. KubeOS is **not** affiliated with,
endorsed by or sponsored by the Kubernetes project, the Cloud Native Computing Foundation, the
Debian project, or the Headlamp maintainers. Debian's logo is not used, and nothing in the product
suggests KubeOS is an official Debian release.

Before a public release, check that the name "KubeOS" is available for your use in your
jurisdiction, and keep the Debian licence files under `/usr/share/doc` intact — removing them would
not be lawful, and the same applies to the package manager's identity (`dpkg`, `apt`) and the
kernel's version string.

---

## 5. What KubeOS deliberately does not do

- It does not strip or replace third-party copyright notices.
- It does not relicense third-party components under the project's own licence.
- It does not ship GPL software without the source route described in section 3.
