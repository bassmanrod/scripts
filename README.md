# scripts

badboyip.pl

If you want to know which IPs are slamming your Apache server constantly within a timeframe, this script will do it.
Provided that you have a default access_log file, run this script on the command line and you will receive a nicely formatted list of the top 10 IPs slamming your Apache server:

  ./badboyip.pl --start 02:26 --end 11:00 --file node0_access_log


FAQ

Q: Do I need modules?

A: Yes, you need the GetOptions::Long module

Q: Can I incorporate this script on the command line and run it remotely?

A Yes, provided that you have your SSH Keys correctly installed

Q: Will you be adding more stuff to the script?

A: Yes, I will be adding more and more goodies.


