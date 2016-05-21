num_iters = 3;

for ii = 1:num_iters

    read_name = ['read_buff' num2str(ii) '.txt'];
    write_name = ['write_buff' num2str(ii) '.txt'];
    
    fid = fopen(read_name,'r');
    read_data = fscanf(fid,'%f');
    fclose(fid);
    
    fid = fopen(write_name,'r');    
    write_data = fscanf(fid,'%f');
    fclose(fid);

    figure(ii);
    plot(write_data,'o');
    hold on
    plot(read_data,'x');
    legend({'Write', 'Read'}, 'Position',[0.6,0.45,0.25,0.1]);
    ylabel('Volts');
    xlabel('Time (us)');
    title_str = ['Iteration ' num2str(ii)];
    title(title_str);
    hold off
    
end
