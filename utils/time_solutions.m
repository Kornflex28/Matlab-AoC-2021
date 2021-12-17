function [times, function_names] = time_solutions()
%TIME_SOLUTIONS Get timing performance of all solutions in seconds

dbs = dbstack('-completenames');
path_parts = strsplit(dbs(1).file, filesep);
home_path = strjoin(path_parts(1:end-2), filesep);

solutions_listing = dir(sprintf('%s/solutions/day*.m',home_path));
[~,function_names,~] = fileparts({solutions_listing.name});

times = zeros(length(function_names),2);
nfunc = length(times);
nrun = 10; % # of runs for each function
for kfun=1:length(times)
    if kfun == 1
        erase_string =  '';
    end
    log_msg = sprintf('Timing function %d/%d\n',kfun,nfunc);
    function_k = str2func(function_names{kfun});
    fprintf(1,'%s%s',erase_string, log_msg)
    truns = zeros(nrun,2);
    for krun=1:nrun
        truns(krun,:) = function_k(0);
    end
    times(kfun,:) = mean(truns,1); % Matlab timeit function use median
    erase_string = repmat(sprintf('\b'), 1, length(log_msg));
end
end

