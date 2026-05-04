ssh sarah@stapp01 "sudo systemctl start httpd"

ssh sarah@stapp01 "sudo chown -R sarah:sarah /var/www/html"

ssh sarah@stapp01 "sudo rm -rf /var/www/html/*"

scp -r /var/lib/jenkins/workspace/devops-app-deployment/* \
sarah@stapp01:/var/www/html/