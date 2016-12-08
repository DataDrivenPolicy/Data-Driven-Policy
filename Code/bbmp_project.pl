use strict;
 use JSON::XS;
use spreadsheet::XLSX;
use Text::Iconv;
use Smart::Comments;
sub clean_row {
	### Running Clean Row
	my ($sheet,$row)=@_;
	my @cells;
                $sheet -> {MaxCol} ||= $sheet -> {MinCol};
		foreach my $col ($sheet -> {MinCol} .. $sheet -> {MaxCol}) {
                my $cellval=$sheet -> {Cells} [$row] [$col]->{Val};
		### Uncleaned Cellval : $cellval
		$cellval=~s/^\s*//;
		$cellval=~s/\s*$//;
		print "CellVal:". $cellval. "\n";
		### Cleaned Cellval : $cellval
		push @cells, $cellval;

		}
		print "Returning Cells". @cells;
		return @cells;
                
}
### Loading Worksheets.
 my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
 my $workbook = Spreadsheet::XLSX -> new ('RawData/Janagraha/Open Works Consolidated.xlsx');
 my $jobSheet = $workbook->worksheet('BBMP Job Codes');
 my $BBMPSheet = $workbook->worksheet('Contractor Bills (BBMP Website)');
 my $IFMSSheet = $workbook->worksheet('Contractor Bills (source IFMS)');
 my $RTISheet = $workbook->worksheet('Contractor Bills (RTI)');

 ### Parsing Jobs Sheet
my @jobs;
my @bills;
 $jobSheet -> {MaxRow} ||= $jobSheet -> {MinRow};
        
         foreach my $row ($jobSheet -> {MinRow}+2 .. $jobSheet -> {MaxRow}) {
		 my @cells=clean_row($jobSheet,$row);
         my$job;
                $job->{SLNo}=$cells[0];
                $job->{Zone}=$cells[1];
                $job->{Assembly}=$cells[2];
                $job->{Division}=$cells[3];
                $job->{Ward_No}=$cells[4];
                $job->{Ward_Name}=$cells[5];
                $job->{Job_Code}=$cells[6];
                $job->{Job_Description}=$cells[7];
                $job->{Estimate}=$cells[8];
                $job->{Budget_Code}=$cells[9];
                $job->{Budget_Head}=$cells[10];
                $job->{Contractor}=$cells[11];
		push @jobs,$job;
        }

	### Parsing BBMP Sheet
 $BBMPSheet -> {MaxRow} ||= $BBMPSheet -> {MinRow};
 my@bills;
         foreach my $row ($BBMPSheet -> {MinRow}+2 .. $BBMPSheet -> {MaxRow}) {
		 my @cells=clean_row($BBMPSheet,$row);
		my $bill;

                $bill->{SLNo}=$cells[0];
                $bill->{Zone}=$cells[1];
                $bill->{Division}=$cells[2];
                $bill->{Ward_No}=$cells[3];
                $bill->{Ward_Name}=$cells[4];
                $bill->{P_Code}=$cells[5];
                $bill->{Job_Code}=$cells[6];
                $bill->{BR_No}=$cells[7];
                $bill->{BR_Date}=$cells[8];
                $bill->{Year}=$cells[9];
                $bill->{Contractor_Name}=$cells[10];
                $bill->{Job_Description}=$cells[11];
                $bill->{Cost_of_the_Work}=$cells[12];
                $bill->{Payment_made}=$cells[13];
                $bill->{Pending_Bill}=$cells[14];
		push @bills,$bill;

         }
	 my $text=encode_json \@bills;
	 open(FILE,">bills_bbmp.json") or die "Unable to open bills JSON file for writing";
	 print FILE $text;
	 close(FILE);
	 ### Parsing RTI Sheet

 $RTISheet -> {MaxRow} ||= $RTISheet -> {MinRow};
 my@bills;
foreach my $row ($RTISheet -> {MinRow}+2 .. $RTISheet -> {MaxRow}) {
	my @cells=clean_row($RTISheet,$row);
	$RTISheet -> {MaxCol} ||= $RTISheet -> {MinCol};

		my $bill;
                
  $bill->{SLNo}=$cells[0];
  $bill->{BR_No}=$cells[1];
  $bill->{BR_Date}=$cells[2];
  $bill->{Job_Code}=$cells[3];
  $bill->{Job_Description}=$cells[4];
  $bill->{Category}=$cells[5];
  $bill->{Ward_No}=$cells[6];
  $bill->{Ward_Name}=$cells[7];
  $bill->{Contractor_Name}=$cells[8];
  $bill->{Cost_of_the_work}=$cells[9];
  push @bills, $bill;
}
my $text=encode_json \@bills;
 open(FILE,">bills_rti.json") or die "Unable to open bills JSON file for writing";
 print FILE $text;
 close(FILE);

 ### PArsing IFMS Sheet
 $IFMSSheet -> {MaxRow} ||= $IFMSSheet -> {MinRow};
 my@bills;
foreach my $row ($IFMSSheet -> {MinRow}+2 .. $IFMSSheet -> {MaxRow}) {
	my @cells=clean_row($IFMSSheet,$row);
  
  $IFMSSheet -> {MaxCol} ||= $IFMSSheet -> {MinCol};
                my $MinCol=$IFMSSheet->{MinCol};
		my $bill;
  
  $bill->{SLNo}=$cells[0];
  $bill->{Zone}=$cells[1];
  $bill->{Division}=$cells[2];
  $bill->{Ward_No}=$cells[3];
  $bill->{Ward_Name}=$cells[4];
  $bill->{P_Code}=$cells[5];
  $bill->{Job_Code}=$cells[6];
  $bill->{Job_Description}=$cells[7];
  $bill->{Contractor_Name}=$cells[8];
  $bill->{Contractor_No}=$cells[9];
  $bill->{BR_No}=$cells[10];
  $bill->{BR_Date}=$cells[11];
  $bill->{CBR_No}=$cells[12];
  $bill->{CBR_Date}=$cells[13];
  $bill->{Rtgs_No}=$cells[14];
  $bill->{Rtgs_Date}=$cells[15];
  $bill->{Gross}=$cells[16];
  $bill->{Deduction}=$cells[17];
  $bill->{Net_Total}=$cells[18];
  $bill->{Gross_P}=$cells[19];
  $bill->{Deduction_P}=$cells[20];
  $bill->{Net_Total_P}=$cells[31];
  push @bills, $bill;


}

### Writing out the JSON Files
my $text=encode_json \@bills;
 open(FILE,">bills_IFMS.json") or die "Unable to open bills JSON file for writing";
 print FILE $text;
 close(FILE);
  

 
my $text=encode_json \@jobs;
 open(FILE,">jobs.json") or die "Unable to open jobs JSON file for writing";
 print FILE $text;
