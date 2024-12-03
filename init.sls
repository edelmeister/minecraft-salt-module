openjdk-21-jdk-headless:
  pkg.installed
minecraft:
  user.present:
    - system: True
    - shell: /bin/bash
    - home: /home/minecraft
    - usergroup: True
/home/minecraft/server.jar:
  file.managed:
    - source:
      - salt://minecraft-salt-module/server.jar
/home/minecraft/eula.txt:
  file.managed:
    - source:
      - salt://minecraft-salt-module/eula.txt
/home/minecraft/server.properties:
  file.managed:
    - source:
      - salt://minecraft-salt-module/server.properties
/etc/systemd/system/minecraft.service:
  file.managed:
    - source:
      - salt://minecraft-salt-module/minecraft.service
build-essential:
  pkg.installed
/usr/local/src/mcrcon:
  file.recurse:
    - source: salt://minecraft-salt-module/mcrcon
make:
  cmd.run:
    - cwd: /usr/local/src/mcrcon
    - unless: test -f /usr/local/src/mcrcon/mcrcon
    - require:
      - file: /usr/local/src/mcrcon
      - pkg: build-essential
'make install':
  cmd.run:
    - cwd: /usr/local/src/mcrcon
    - unless: test -f /usr/local/bin/mcrcon
    - require:
      - cmd: make
minecraft.service:
  service.running:
    - watch:
      - file: /home/minecraft/server.properties
      - file: /home/minecraft/server.jar
      - file: /etc/systemd/system/minecraft.service
