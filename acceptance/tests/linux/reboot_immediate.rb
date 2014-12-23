test_name "Reboot Module - Linux Provider - Reboot Immediately"
extend Puppet::Acceptance::Reboot

reboot_manifest = <<-MANIFEST
notify { 'step_1':
}
~>
reboot { 'now':
}
MANIFEST

confine :except, :platform => 'windows'

linux_agents.each do |agent|
  step "Reboot Immediately with Refresh"

  #Apply the manifest.
  on agent, puppet('apply', '--debug'), :stdin => reboot_manifest

  #Verify that a shutdown has been initiated and clear the pending shutdown.
  retry_shutdown_abort(agent)
end
