#!/usr/bin/env bash

puppet epp render server.conf.epp --values '{ key_name => test, keys_dir => "/tmp/openvpn/keys", log_dir => "/tmp/openvpn/logs", port => 1000, proto => udp, dev => tun, server => "10.8.0.0 255.255.255.0", routes => ["10.20.30.0 255.255.255.0"], user => nobody, group => nobody, cipher => undef, max_clients => 10  }'