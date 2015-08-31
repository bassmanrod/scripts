# scripts

badboyip.pl

If you want to know which IPs are slamming your Apache server constantly within a timeframe, this script will do it.
Provided that you have a default access_log file, run this script on the command line and you will receive a nicely formatted list of the top 10 IPs slamming your Apache server:

  ./badboyip.pl --start 02:26 --end 11:00 --file node0_access_log

54.xxx.xxx.xx          6420       
24.xxx.xxx.xx          1720       
192.xxx.xx.x           1028       
173.xxx.xx.xxx          640        
127.xxx.xx.xx           633        
xxx.xxx.xxx.xxx         283        
50.xxx.xxx.xx.xx        279        
123.xxx.xxx.xxx         279        
xxx.xxx.xxx.xx x        272

FAQ

Q: Do I need modules?
A: Yes, you need the GetOptions::Long module

Q: Can I incorporate this script on the command line and run it remotely?
A Yes, provided that you have your SSH Keys correctly installed

Q: Will you be adding more stuff to the script?
A: Yes, I will be adding more and more goodies.


