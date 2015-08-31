# scripts

badboyip.pl

If you want to know which IPs are slamming your Apache server constantly within a timeframe, this script will do it.
Provided that you have a default access_log file, run this script on the command line and you will receive a nicely formatted list of the top 10 IPs slamming your Apache server:

./badboyip.pl --start 02:26 --end 11:00 --file node0_access_log


