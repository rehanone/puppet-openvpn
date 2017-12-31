#!/usr/bin/env bash

puppet epp render client.epp --values '{ key_name => test, keys_dir => "/tmp/openvpn/keys", port => 1000, proto => udp, dev => tun, server => "rehan.no-ip.biz", user => nobody, group => undef, cipher => tls  }'