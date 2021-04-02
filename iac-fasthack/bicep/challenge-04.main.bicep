param adminUserName string = 'jason'
@secure()
param adminPassword string
param cseInstallApache string = '''
#!/bin/bash

# install Apache (in a loop because a lot of installs happen
# on VM init, so won't be able to grab the dpkg lock immediately)
until apt-get -y update && apt-get -y install apache2
do
  echo "Try again"
  sleep 2
done

# write some HTML
echo '<center\><h1\>Welcome to What The Hack: IaC ARM Template Challenges</h1\><br/>\</center>' > /var/www/html/wth.html

# restart Apache
apachectl restart
'''

module network './challenge-04.network.bicep' = {
  name: 'networkDeploy'
}

module lb './challenge-04.lb.bicep' = {
  name: 'lbDeploy'
}

module vmss './challenge-04.vmss.bicep' = {
  name: 'vmssDeploy'
  params: {
    adminUsername: adminUserName
    adminPassword: adminPassword
    nsgId: network.outputs.nsgId
    subnetId: network.outputs.subnetId
    lbId: lb.outputs.lbId
    bePoolName: lb.outputs.backendPoolName
    cseScriptBlock: cseInstallApache
  }
}

// az deployment group create -f .\challenge-04.main.bicep -g iac-fasthack

// PS 7 does not work
// New-AzResourceGroupDeployment -ResourceGroupName iac-fasthack -TemplateFile .\challenge-04.main.bicep