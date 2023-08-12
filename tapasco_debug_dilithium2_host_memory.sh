#!/bin/sh

tapasco -v compose [ dilithium2_sign x 1 ] @ 50 MHz --deleteProjects false -p vc709  --features 'Debug { interfaces: "{/arch/target_ip_00_000/internal_target_ip_00_000/s_axi_control /arch/target_ip_00_000/internal_target_ip_00_000/ap_clk /arch/target_ip_00_000/internal_target_ip_00_000/ap_rst_n }" }, Debug { interfaces: "{/arch/out_0/M000_AXI /arch/out_0/m_aclk /arch/out_0/m_interconnect_aresetn }" }'
