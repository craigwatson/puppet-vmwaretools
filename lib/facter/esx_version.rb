require 'facter'

# Author: Francois Deppierraz <francois.deppierraz@nimag.net>
# Idea and address/version mapping comes from
# http://virtwo.blogspot.ch/2010/10/which-esx-version-am-i-running-on.html

Facter.add(:esx_version) do
  confine :virtual => :vmware
  setcode do
    if File::executable?("/usr/sbin/dmidecode")
      result = Facter::Util::Resolution.exec("/usr/sbin/dmidecode 2>&1")
      if result
        begin
          bios_address = /^BIOS Information$.+?Address: (0x[0-9A-F]{5})$/m.match(result)[1]

          case bios_address
            when '0xE8480'
              '2.5'
            when '0xE7C70'
              '3.0'
            when '0xE7910'
              '3.5'
            when '0xEA6C0'
              '4'
            when '0xEA550'
              '4 update 1'
            when '0xEA2E0'
              '4.1'
            when '0xE72C0'
              '5'
            when '0xEA0C0'
              '5.1'
            when '0xEA050'
              '5.5'
            else
              "unknown, please report #{bios_address}"
          end
        rescue
          'n/a'
        end
      end
    end
  end
end
