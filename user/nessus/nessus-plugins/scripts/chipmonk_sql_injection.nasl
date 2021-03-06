#
# (C) Tenable Network Security
#

if(description)
{
 script_id(16319);
 script_bugtraq_id(12456);
 
 script_version ("$Revision: 1.3 $");
 name["english"] = "ChipMonk Forum SQL Injection";
 script_name(english:name["english"]);
 
 desc["english"] =  "
The remote host is running ChipMonk, a web-based forum 
written in PHP.

The remote version of this software is vulnerable to several SQL
injection vulnerabilities which may allow an attacker to execute
arbitrary SQL statements on the remote SQL database.

Solution : Upgrade to the latest version of this software
Risk factor : High";

 script_description(english:desc["english"]);
 
 summary["english"] = "Checks if ChipMonk forum is vulnerable to a SQL injection attack";
 
 script_summary(english:summary["english"]);
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2005 Tenable Network Security");
 family["english"] = "CGI abuses";
 script_family(english:family["english"]);
  script_dependencie("cross_site_scripting.nasl");
  script_require_ports("Services/www", 80);
 script_exclude_keys("Settings/disable_cgi_scanning");
 exit(0);
}

# The script code starts here

include("http_func.inc");
include("http_keepalive.inc");

port = get_http_port(default:80);

if(!get_port_state(port)) exit(0);
if(!can_host_php(port:port)) exit(0);

foreach dir ( cgi_dirs() )
{
 if ( is_cgi_installed_ka(item:dir + "/getpassword.asp", port:port) )
 {
 data = "email='&submit=submit";
 
 req = http_post(item:dir + "/getpassword.php", port:port);
 idx = stridx(req, '\r\n\r\n');
 req = insstr(req, '\r\nContent-Length: ' + strlen(data) + '\r\n' + 
 'Content-Type: application/x-www-form-urlencoded\r\n\r\n' + data, idx);
 
 
 res = http_keepalive_send_recv(port:port, data:req);
 if ( res == NULL ) exit(0);
 if("<link rel='stylesheet' href='style.css' type='text/css'>Could not get info" >< res )
  {
  security_hole(port);
  exit(0);
  }
 }
}
