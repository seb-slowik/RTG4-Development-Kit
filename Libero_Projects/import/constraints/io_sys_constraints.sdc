# Constraint for the 50MHz fabric clock
create_clock -name {REF_CLK} -period 20 -waveform {0 10 } [ get_ports { REF_CLK } ]


