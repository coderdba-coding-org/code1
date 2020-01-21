This uses virtual namespaces - which are served by intermediary systems which simulate kubernetes API.  
Those intermediary systems in turn loop through various kubernetes clusters defined under those virtual namespaces.  

For example lab-kube-system may be a virtual namespace which refers to kube-system namespace in all lab clusters.  
