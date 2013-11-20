require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/6.2/smartmontools-6.2.tar.gz'
  sha1 '37848ff5103d68b672463a30cd99e7d23d6696a5'

  def install
    (var/'run').mkpath
    (var/'lib/smartmontools').mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-drivedb",
                          "--enable-savestates",
                          "--enable-attributelog"
    system "make install"
    
        # smartmontools plist for smartd service
    (prefix+'homebrew.mxcl.smartmontools.plist').write plist_smartd
    (prefix+'homebrew.mxcl.smartmontools.plist').chmod 0644

  end
  plist_options :startup => false

  def plist_smartd
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
    <key>Label</key><string>#{plist_name}</string>
    <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/sbin/smartd</string>
        <string>-n</string>
      </array>
    <key>Disabled</key><false/>
    <key>KeepAlive</key><false/>
    <key>RunAtLoad</key><true/>
    <key>LowPriorityIO</key><true/>
    <key>WatchPaths</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/etc/smartd.conf</string>
    </array>
    </dict>
    </plist>
    EOS
  end
  def user_nm; ENV['USER'] end
  def caveats; <<-EOS.undent
    Before starting smartd service, edit smartd.conf file. Sample smartd.conf file may be found in #{etc}.
    A useful smartd.conf to automatically run tests needs only one non-comment line such as:
    DEVICESCAN -a -o on -S on -n standby,q -l selftest -I 194 -m #{user_nm} -M test -s (S/../.././12|L/../../6/13)
    The -M test writes a test message to /var/mail/. Experimental -m @ALL can also run alert scripts in
    /usr/local/etc/smartd_warning.d/ that can run growlnotify (10.5-10.7) or terminal-notifier (10.8+)
    But, if smartd is run as root, such scripts may hang (which hangs smartd), or fail to alert non-root users.
    So, use sudo ONLY if you know what you are doing: both smartd (and smartctl) run fine in osX as non-root.
    In case of drive-warning, try smartctl gui-wrapper: gsmartmontools, free SMARTReporter2.7, non-free DriveDX.
    You can also smart-test usb/fw drives with "OS-X-SAT-SMART-Driver" tho smartd.conf  may need "-d removable".
    
    Do sanity tests of your #{etc}/smartd.conf before you 'brew services restart smartmontools' such as:
        #{HOMEBREW_PREFIX}/sbin/smartd  --version
        #{HOMEBREW_PREFIX}/sbin/smartd  -q  showtests
        #{HOMEBREW_PREFIX}/sbin/smartd  -q  onecheck
    The onecheck should create state and attrib files in #{var}/lib/smartmontools
        
    After above sanity tests look ok, then you can see if smartd runs automatically (without sudo) by:
        brew services restart smartmontools
        ps -ef | grep smartd  (assuming smartd did not quit due to errors, should show 'smartd -n' running)
    If smartd dies, KeepAlive=false so launchd won't restart it, but 'touch smartd.conf' should restart it.
    EOS
  end
end
