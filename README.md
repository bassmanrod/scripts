# scripts

badboyip.pl

If you want to know which IPs are slamming your Apache server constantly within a timeframe, this script will do it.
Provided that you have a default access_log file, run this script on the command line and you will receive a nicely formatted list of the top 10 IPs slamming your Apache server:

      ./badboyip.pl --start 02:26 --end 11:00 --file node0_access_log


FAQ

Q: Do I need modules?

A: Yes, you need the GetOptions::Long module

Q: Can I incorporate this script on the command line and run it remotely?

A Yes, provided that you have your SSH Keys correctly installed:

    Example: for x in {2,3,6,7}; do ssh rod@192.168.0.$x "hostname;perl - "<./badboyip.pl --start 10:00 --end 11:00 --file /var/log/httpd/access_log;done

Q: Will you be adding more stuff to the script?

A: Yes, I will be adding more and more goodies.

Q: Will you entertain enhancement requests?

A Abso-freakin-lutely!


