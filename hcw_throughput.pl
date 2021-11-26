#Network and Computer Communication, ICTU, 10/2017
# Type: perl hcw_throughput.pl <trace_file> <source_node> <destination_node>
# To compute average throughput during simulation time
# of the flow "flow id" at the node "required node"
#Thong luong TB = Tong kich thuoc goi tin nhan duoc/(Thoi gian nhan goi tin cuoi cung - thoi gian nhan goi tin dau tien)
# ---------------------------------------------

$infile = $ARGV[0];
$src=$ARGV[1];
$dest=$ARGV[2];
$start_time=0;
$end_time=0;
$source=0; #source node
$destination=0; #destination node
$recv_num =0; #size of received packets in destination node

# --------------------------------------------
$sum=0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
$source = substr($x[13],1,2);
if($source>=10){$source = $source;}
else {$source = substr($source,0,1);}

$destination = substr($x[14],0,2);
if($destination>=10){$destination = $destination;}
else {$destination = substr($destination,0,1);}

if($x[0] eq 'r' && $source ==$src && $destination==$dest && $x[3] eq 'AGT' && $x[6] eq 'cbr'||$x[6] eq 'tcp'){
   if($start_time==0){$start_time = $x[1];}
  $recv_num = $recv_num + $x[7];
   $end_time = $x[1];
 }
}
$throughput_byte=$recv_num/($end_time -$start_time);
$throughput_kbit=$throughput_byte*8/1024;
print STDOUT "\nstart_time = $start_time\t";
print STDOUT "end_time = $end_time\n\n";
print STDOUT "Avg throughtput(source_node = $src; destination_node = $dest) =$throughput_kbit(Kbps)\n\n";
close DATA;
exit(0);
