!/usr/local/bin/perl
# This is the absolute pathname of the BBS file.
$guestbook="/home/zach/public_html/guestbook.html";

# This is the url of that file on the web server.
$entriespage="http://tilde.town/~zach/guestbook.html";

# This is the email address of the maintainer.
$maintainer="zach/@tilde.town";

if ($ENV{'REQUEST_METHOD'} eq 'POST') {

		# Get the input

    read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

		# Split the name-value pairs

    @pairs = split(/&/, $buffer);

		# Load the FORM variables

    foreach $pair (@pairs) {
        ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

        $FORM{$name} = $value;
    }

				
    open (GUESTBOOK,">> $guestbook");
$currenttime=localtime;

		# Put the new log entry in.


    print GUESTBOOK "$currenttime from $ENV{'REMOTE_HOST'}<BR>\n";
    
    print GUESTBOOK "<FONT SIZE=+1>$FORM{name}";
	if ($FORM{email} ne "") {
    print GUESTBOOK "&nbsp;&lt;<A HREF=\"mailto:$FORM{email}\"><I>$FORM{email}</I></A>&gt;&nbsp;"; }

    print GUESTBOOK "\n"; 
	if ($FORM{url} ne "") {
    print GUESTBOOK "(<A HREF=\"$FORM{url}\">Home Page</A>)"; }
    print GUESTBOOK "</FONT><P>\n";
    print GUESTBOOK "$FORM{comments}<HR><P>\n";
    close (GUESTBOOK);
		# Thank the user and acknowledge 
		# the feedback
    &thank_you;
} 

&sub_error;

sub sub_error { 	
		# Format an error message for the user

    print "Content-type: text/html\n\n";
    print "<HTML>\n";
    print "<HEAD>\n";
    print "<TITLE>Guestbook Form Error</TITLE>\n";
    print "</HEAD>\n";
    print "<BODY>\n";
    print "<H1>Guestbook Form Error</H1>\n";
    print "<HR>\n";
    print "<P>\n";
    print "Form input was not proccessed.  Please mail your ";
    print "remarks to $maintainer\n";
    print "</BODY>\n";
    print "</HTML>\n";
}
sub evil_characters {

    print "Content-type: text/html\n\n";
    print "<HTML>\n";
    print "<HEAD>\n";
    print "<TITLE>Illegal Email Address</TITLE>\n";
    print "</HEAD>\n";
    print "<BODY>\n";
    print "<H1>Illegal Email Address</H1>\n";
    print "<HR>\n";
    print "<P>\n";
    print "The Email address you entered contains illegal";
    print "characters. Please back up and correct, then resubmit.\n";
    print "</BODY>\n";
    print "</HTML>\n";
}
sub thank_you {

    print "Content-type: text/html\n\n";
    print "<HTML>\n";
    print "<HEAD>\n";
    print "<TITLE>Thank You!</TITLE>\n";
    print "</HEAD>\n";
    print "<BODY BGCOLOR=#FFFFFF TEXT=#000000>\n";
    print "<H1>Thank You!</H1>\n";
    print "\n";
    print "<P>\n";
    print "<H3>YOU ARE GREAT! IT'S RIDICULOUS..<BR>\n";
    print "Click here to <A HREF=$ENV{'REFERRER'}>Back</A>, or check out the guestbook <A HREF=$entriespage>entries</A>.\n";
    print "<P>\n";
    print "<I>$maintainer</I>\n";
    print "</BODY>\n";
    print "</HTML>\n";
    exit(0);
}