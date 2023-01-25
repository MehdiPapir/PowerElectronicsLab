file = ['ac_grid_connnected'; 'Power_Electronic_Lab_Controllers'; 'power_electronics'];

for i = 1:length(file)
    open(file(i))
    set_param(gcs,'EnableLBRepository','on')
    close(file(i))
end