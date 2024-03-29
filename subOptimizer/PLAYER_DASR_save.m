function [y] = PLAYER_DASR_save(option)
if exist([option.path,option.name(option.num,option.iter)],'file')
    ld = load([option.path,option.name(option.num,option.iter)]);
    opt = ld.opt;
    option.max = option.max-(size(opt.Sample.samples_h,1)-opt.Sample.ini_number)/size(option.variables,2);
    if option.max>0
        option.save = 1;
        y = PLAYER_DASR(option,opt);
    else
        borderOld = option.border;
        ratio = 0.2;
        y = opt.best;
        y.borderNew = spaceReduce(@(x)opt.Model.predict(x),borderOld,ratio);
        list = LooCV(opt.Model);
        y.R2 = list.R2;
        y.sensitive =iteraction(opt.Model,y.borderNew);
    end
else
    y = PLAYER_DASR(option);
end
end

