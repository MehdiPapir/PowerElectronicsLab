
cs = 'TempLib.slc';
%set_param(cs,'EnableLBRepository','on')

LBR = get_param(cs,'EnableLBRepository');
disp(LBR)