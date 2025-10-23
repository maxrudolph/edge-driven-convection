% load and plot 'statistics' files from aspect output
clear; close all;
filename = 'output-convection-box-1e1/statistics';

delimiter = ' ';
startRow = 22;
fh =fopen(filename,'r');
% read the header info
field=1;
while ~feof(fh)
    line = fgetl(fh);
    if(line(1) == '#')
        disp(line)
        colpos = find(line == ':',1,'first');
        column_number = sscanf(line(2:(colpos-1)),'%d');
        description = line(colpos+1:end);
        meta{column_number} = description;
        field = field + 1;
    else
        break;
    end
end
fclose(fh);
% read the data
startrow = field; % skip the first (field-1) rows
fh = fopen(filename,'r');
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%[^\n\r]';% note this assumes 21 columns the last of which is text
dataArray = textscan(fh, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fh);

statistics.meta = meta;
statistics.data = dataArray;

%% Plot a specific field
x_column = 2;
y_column = 11;

figure()
plot( statistics.data{x_column}, statistics.data{y_column} )
xlabel( statistics.meta{x_column} )
ylabel( statistics.meta{y_column} )

%% multiplot
x_column = 2;
y_columns = [11 12 20];
nsp = length(y_columns);
figure()
for i=1:nsp
    subplot(nsp,1,i);
    y_column = y_columns(i);
    plot( statistics.data{x_column}, statistics.data{y_column} )
    xlabel( statistics.meta{x_column} )
    ylabel( statistics.meta{y_column} )

end

