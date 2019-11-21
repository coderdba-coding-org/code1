cfssl gencert \
-ca=/etc/kubernetes/pki/ca.pem \
-ca-key=/etc/kubernetes/pki/ca-key.pem \
-config=ca-config.json \
-profile=kubernetes user-kubesystem-csr.json | \
cfssljson -bare user-kubesystem
