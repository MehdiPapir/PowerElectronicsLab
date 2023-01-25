function SinglePhaseLCLFIlterDesigner(choise)
%#ok<*ST2NM>
    Pn  = str2num(get_param(gcb, 'Pnom'));
    Vn  = str2num(get_param(gcb, 'Vnom'));
    Vdc = str2num(get_param(gcb, 'DC_Vol'));
    f   = str2num(get_param(gcb, 'f'));
    fsw = str2num(get_param(gcb, 'fsw'));

    cas = get_param(gcb, 'is_cascaded');
    adv = get_param(gcb, 'advance_designer');
    typ = get_param(gcb, 'des_type');

    if strcmp(cas, 'on')
      module = str2num(get_param(gcb, 'module'));
      phase  = str2num(get_param(gcb, 'phase'));
    else
      module = 1;
      phase  = 1;
    end
    Zb = (Vn^2)/Pn;
    wg = 2*pi*f;
    I_max = Pn * module * phase * sqrt(2) / (3 * Vn / sqrt(3));
    Cb = 1 / (wg * Zb);
    
    switch choise
        case 'desinger'
            if strcmp(adv, 'on')
                dvm = str2num(get_param(gcb, 'dVmax'));
                dim = str2num(get_param(gcb, 'dImax'));
            else
                dvm = 0.05;
                dim = 0.5;
            end
            dI_max = dim * I_max;
            L1 = Vdc / (6*fsw*dI_max);
            Cb = 1 / (wg * Zb);
            Cf = Cb * dvm;
            if strcmp(typ, 'dep. r')
                r  = str2num(get_param(gcb, 'r'));
                L2 = r*L1;
            else
                ka = str2num(get_param(gcb, 'ka'));
                L2 = (abs(1/ka) + 1) / (Cf * (2*pi*fsw)^2);
            end
            wres = sqrt((L1+L2)/(L1*L2*Cf));
            fres = wres/(2*pi);
            Rf = 1 / (wres * Cf);
            set_param(gcb, 'L1', num2str(L1))
            set_param(gcb, 'L2', num2str(L2))
            set_param(gcb, 'Cf', num2str(Cf))
            set_param(gcb, 'Rf', num2str(Rf))
            set_param(gcb, 'fres', num2str(fres))
            
        case 'calculator'
            L1 = str2num(get_param(gcb, 'L1'));
            L2 = str2num(get_param(gcb, 'L2'));
            Cf = str2num(get_param(gcb, 'Cf'));
            
            dI_max = vd / (6*fsw*L1);
            dim = dI_max / I_max;
            dvm = Cf * wg * Zb;
            wres = sqrt((L1+L2)/(L1*L2*Cf));
            fres = wres/(2*pi);
            Rf = 1 / (wres * Cf);
            
            set_param(gcb, 'Rf'   , num2str(Rf)  )
            set_param(gcb, 'fres' , num2str(fres))
            if strcmp(adv, 'on')
                set_param(gcb, 'dVmax', num2str(dvm) )
                set_param(gcb, 'dImax', num2str(dim) )
            end
    end
end