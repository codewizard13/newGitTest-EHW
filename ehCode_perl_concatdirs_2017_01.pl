#================================================================
#
# Repo Name:        EHW-MergeUnsavedNPPFiles 
# File Name:        ehCode_perl_concatdirs_2017_01.pl
# Date Created:     10/05/15
# Date Modified:    02/13/17 
# Programmer:       Eric Hepperle
#
# Purpose: Get all files in dir and concat them together, adding a 
#    filename to the top of each new section. This is most useful
#    when archiving open but unsaved NotePad++ files.
#
# Usage: 
#
# URL: https://github.com/codewizard13/EHW-MergeUnsavedNPPFiles
#
#================================================================

use warnings;

use Cwd;

print "Hello World!\n\n";

#================================================================
# VARIABLES:
#================================================================

#my $bar = '-'x45,"\n";

# Working path:
#  '/c/Users/User1/AppData/Roaming/Notepad++/backup';
my $nppPath = $ENV{APPDATA} . '\Notepad++\backup';
print "DEBUGGING ...\n";
print "\t\$nppPath = \"$nppPath\"\n\n";
<STDIN>;

# Finds all files with 'new' in the title, which is the format
#  used by NotePad++ unsaved files.
my @dirContents = `ls "$nppPath" | grep 'new '`;


# chdir($nppPath);

# confirm chdir:
# print "\tCurrent working directory after change is: \n" . `pwd`;

print "\$dirContents:\n\n";

my $out = joinFileContents(@dirContents);
print $out;

# write joined file contents to joinfile
my $outfileName = 'eh_masterjoined_01.txt';
open FH, '>', $outfileName or die "Can't open file $!";
print FH $out;

#================================================================
# SUBROUTINES:
#================================================================

sub joinFileContents {

    my (@dirContents) = @_;
    
	my $rootPath = `pwd`;
	print "\$rootPath = $rootPath\n";
    
    my $outStr = '';
	
    foreach my $filename (@dirContents) {
    
        # Remove newline from $filename.
        chomp($filename);
        $fullPath = $nppPath . '/' . $filename;
		# print "FILENAME TO OPEN: $filename\n";
		open my $FH, '<', $fullPath or die "Can't open file {$fullPath}[$!]";
		# print "Successfully opened:\t$filename\n";
        
        # verify contents:
        my $fileContents = do { local $/; <$FH> };
        # print "\n\n$bar\n\n";
        # print "File Contents:\n\n$fileContents\n";
        
        # print bar and contents
        $outStr .= nameBar($filename) . "\n\n" . $fileContents . "\n\n";
        
	}
=begin comment    
     print nameBar("Eric's Name Bar", 69);
     print nameBar("Apples", 48);
     print nameBar("Incredible Hulk");
=cut    
    return $outStr;
}

sub nameBar {
    
    my ($name, $barlen) = @_;
    
    
    # default bar length.
    my $barLen = $barlen ? $barlen : 60;
    my $nameLen = length($name);
    my $topBar = '#'x$barLen;
    my $bottomBar = '#'x$barLen;
    
=begin comment    
    print "\$name = $name\n\n";
    print "\$topBar = $topBar\n";
    print "\$barLen = $barLen\n";
    print "\$nameLen = $nameLen\n";
    print "\$bottomBar = $bottomBar\n";
=cut   
    my $nameStartPoint = int($barLen / 2) - int($nameLen / 2);
    my $barCharsFront = $nameStartPoint - 1;
    my $barCharsRear = $barLen - ($barCharsFront + $nameLen);
    my $midBar = '##' . ' 'x ($barCharsFront - 2) . $name . ' 'x ($barCharsRear - 2) . '##';

=begin comment    
    print "NAME WILL START AT CHARACTER [$nameStartPoint] of the bar\n\n";
    print "\$barCharsFront = $barCharsFront\n\n";
    print "\$midBar =\n$midBar\n" . length($midBar) . "\n\n";
=cut    
    # my $fullBar = "\t$topBar\n\t$midBar\n\t$bottomBar\n\n";
    my $fullBar = "\t$topBar\n\t$midBar\n\t$bottomBar\n\n";
    return $fullBar;

}

#================================================================
#
# NOTES:
#
#    10/05/15 - This version concats the files but needs work
#                on how to display filename and bars. Currently
#                working on how to center the filename in the
#                bar, but Perl modulus (%) operator behavior
#                needs examination.
#
#    10/06/15 - Works. Adds namebar and contents to
#                  screen. Next is to get it to write
#                  out to a file.    
#
#    10/07/15 - Works and writes to joinfile! :).
#
#    02/13/17 - Began working on version 2.
#             - Cleaned up file and section documentation.
#             - STUCK trying to figure out how to get
#                  %APPDATA% path in GitBash Perl on Win 10.
#
#================================================================
