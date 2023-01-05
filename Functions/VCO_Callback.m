function VCO_Callback()
%#ok<*TRYNC>

	persistent old_sel
	if isempty(old_sel)
		old_sel = get_param(gcb, 'input_sel');
	end
	
    theta_path = strjoin({gcb, 'theta'}, '/');
    omega_path = strjoin({gcb, 'omega'}, '/');
    source = 'simulink/Sources/In1';

    sel = get_param(gcb, 'input_sel');
    if strcmp(old_sel, sel)
        return
    end
    old_sel = sel;
    switch sel
    case 'Arc'
        if (getSimulinkBlockHandle(theta_path) == -1)
          add_block(source, theta_path, 'Position', ...
          [60 -7 90 7], 'Port', '1', 'ShowName', 'off')
          add_line(gcb, 'theta/1', 'Sum3/1');
        end
        try
          delete_line(gcb, 'omega/1', 'Integrator/1')
          delete_block(omega_path)
        end
    case 'Freq'
        if (getSimulinkBlockHandle(omega_path) == -1)
          add_block(source, omega_path, 'Position', ...
          [60 38 90 52], 'Port', '1', 'ShowName', 'off');
          add_line(gcb, 'omega/1', 'Integrator/1')
        end
        try
          delete_line(gcb, 'theta/1', 'Sum3/1');
          delete_block(theta_path);
        end
    case 'Arc & Freq'
        if (getSimulinkBlockHandle(theta_path) == -1)
          add_block(source, theta_path, 'Position', ...
          [60 -7 90 7], 'Port', '1', 'ShowName', 'off')
          add_line(gcb, 'theta/1', 'Sum3/1');
        end
        if (getSimulinkBlockHandle(omega_path) == -1)
          add_block(source, omega_path, 'Position', ...
          [60 38 90 52], 'Port', '2', 'ShowName', 'off');
          add_line(gcb, 'omega/1', 'Integrator/1')
        end
    end
end