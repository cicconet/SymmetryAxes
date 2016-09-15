edgesin = 0;
for experiment = 1:4
    fprintf('experiment %d\n', experiment);
    switch experiment
        case 1,
            dirpath2 = '/testing_upenn/single'; nimages = 40; stmaxlencoef = 0.5; noutputs = 10; sortouts = 0; sqvotes = 0; % sortouts: 0, 1
        case 2,
            dirpath2 = '/testing_ours/single'; nimages = 176; stmaxlencoef = 0.5; noutputs = 1; sortouts = 1; sqvotes = 1;
        case 3,
            dirpath2 = '/testing_upenn/multiple'; nimages = 30; stmaxlencoef = 0.3; noutputs = 25; sortouts = 1; sqvotes = 0;
        case 4,
            dirpath2 = '/testing_ours/multiple'; nimages = 63; stmaxlencoef = 0.3; noutputs = 25; sortouts = 1; sqvotes = 1;
    end

    parfor imindex = 1:nimages
        fprintf('.');
        main_symaxes(imindex,dirpath2,stmaxlencoef,noutputs,sortouts,sqvotes,edgesin)
    end
    fprintf('\n')

    mode = {'segments', 'lines'};
    if experiment >= 1 && experiment <= 2
        for i = 1:2
            eval_symaxis(mode{i},dirpath2,nimages,edgesin)
        end
    else
        for i = 1:2
            eval_symaxis_m(mode{i},dirpath2,nimages,edgesin)
        end
    end
end