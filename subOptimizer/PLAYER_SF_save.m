function [y] = PLAYER_SF_save(option)
option.save = 1;
if exist([option.path,option.name(option.num,option.iter)],'file')
    ld = load([option.path,option.name(option.num,option.iter)]);
    opt = ld.opt;
    option.max = option.max-(size(opt.Sample.samples_h,1)-opt.Sample.ini_number)/size(option.variables,2);
    if option.max>0
        y = PLAYER_DASR(option,opt);
    else
        y = opt;
    end
else
    y = PLAYER_SF(option);
end
end

