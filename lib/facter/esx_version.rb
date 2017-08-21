require 'facter'

# Author: Francois Deppierraz <francois.deppierraz@nimag.net>
# Idea and address/version mapping comes from
# http://virtwo.blogspot.ch/2010/10/which-esx-version-am-i-running-on.html

Facter.add(:esx_version) do
  confine virtual => 'vmware'
  setcode do
    if File.executable?('/usr/sbin/dmidecode')
      result = Facter::Util::Resolution.exec('/usr/sbin/dmidecode 2>&1')
      if result
        begin
          bios_address = %r{^BIOS Information$.+?Address: (0x[0-9A-F]{5})$}m.match(result)[1]

          case bios_address
          when '0xE8480'
            '2.5'
          when '0xE7C70'
            '3.0'
          when '0xE66C0'
            '3.5'
          when '0xEA550'
            '4.0'
          when '0xEA2E0'
            '4.1'
          when '0xE72C0'
            '5.0'
          when '0xEA0C0'
            '5.1'
          when '0xE9AB0'
            '5.1 update 3'
          when '0xEA050'
            '5.5'
          when '0xE9A40'
            '6.0'
          when '0xE99E0'
            '6.0 update 2'
          when '0xEA580'
            '6.5'
          else
            "Unknown, please report #{bios_address}"
          end
        rescue
          'n/a'
        end
      end
    end
  end
end
