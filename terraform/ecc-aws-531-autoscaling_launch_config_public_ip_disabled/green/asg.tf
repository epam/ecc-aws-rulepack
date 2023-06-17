# There is a bug where 'associate_public_ip_address' has a 3 states when terraform can only provide 2 states.

# Use following command to create green infrastructure.
aws autoscaling create-launch-configuration --launch-configuration-name 531_launch_template_green --image-id ami-06eecef118bbf9259 --instance-type t2.micro --no-associate-public-ip-address

# Use following command to delete infrastructure.
aws autoscaling delete-launch-configuration --launch-configuration-name 531_launch_template_green