#!/bin/bash

yum -y update
yum -y install httpd

cat <<EOF > /var/www/html/index.html
<html>
<h2>Built by Terraform <font color="red">v0.12</font></h2><br>
Owner: ${f_name} ${l_name}<br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

systemctl enable httpd
systemctl start httpd