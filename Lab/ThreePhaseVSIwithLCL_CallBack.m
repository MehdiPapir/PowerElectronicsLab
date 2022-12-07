function ThreePhaseVSIwithLCL_CallBack(scope)
%Three Phase VSI with LCL General CallBack - Description
%
% Syntax: ThreePhaseVSIwithLCL_CallBack(scope)
%
% Long description
	persistent old_dc_pop old_loop_pop old_m_pop old_v_label old_c_label
	persistent voltage_sink current_sink
	if isempty(old_dc_pop)
		old_dc_pop = 'Internal';
	end
	if isempty(old_loop_pop)
		old_loop_pop = 'Current';
	end
	if isempty(old_m_pop)
		old_m_pop = 'Yes, with Port';
	end
	if isempty(old_c_label)
		old_v_label = 'Vout';
		old_c_label = 'Iout';
	end
	if isempty(voltage_sink)
		voltage_sink.name = 'Vout';
		voltage_sink.port = strjoin({voltage_sink.name, '1'}, '/');
		voltage_sink.path = strjoin({gcb, voltage_sink.name}, '/');
		voltage_sink.source = 'simulink/Sinks/Out1';
		voltage_sink.type = 'port';
		voltage_sink.handler = 0;
		voltage_sink.position = [710, 148, 740, 162];
		voltage_sink.linkPoints = [627, 245; 627, 155; 705, 155];
		
		current_sink.name = 'Iout';
		current_sink.port = strjoin({current_sink.name, '1'}, '/');
		current_sink.path = strjoin({gcb, current_sink.name}, '/');
		current_sink.source = 'simulink/Sinks/Out1';
		current_sink.type = 'port';
		current_sink.handler = 0;
		current_sink.position = [710, 183, 740, 197];
		current_sink.linkPoints = [644, 260; 644, 190; 705, 190];
	end

	switch scope
	case 'MeasurementPopup'
		mask = Simulink.Mask.get(gcbh);
		m_pop = get_param(gcb, 'm_pop');
		vLabel = mask.getParameter('v_label');
		cLabel = mask.getParameter('c_label');

		if ~strcmp(old_m_pop, m_pop)
			old_m_pop = m_pop;
			switch m_pop
            case 'Yes, with Port'
                vLabel.Visible = 'off';
                cLabel.Visible = 'off';
                voltage_sink.type = 'port';
				try
					voltage_sink.handler = add_block(voltage_sink.source, voltage_sink.path, ...
					'Position', voltage_sink.position);
					current_sink.handler = add_block(current_sink.source, current_sink.path, ...
					'Position', current_sink.position);
					add_line(gcb, voltage_sink.linkPoints);
					add_line(gcb, current_sink.linkPoints);
				end

            case 'Yes, with Label'
                cLabel.Visible = 'on';
                vLabel.Visible = 'on';
                voltage_sink.type = 'label';
				try
					delete_line(gcb, 'T1/1', voltage_sink.port);
					delete_line(gcb, 'T1/2', current_sink.port);
					delete_block(voltage_sink.path);
					delete_block(current_sink.path);
				end
				
            case 'No Measure'
                cLabel.Visible = 'off';
                vLabel.Visible = 'off';
                voltage_sink.type = 'none';
				try
					delete_line(gcb, 'T1/1', voltage_sink.port);
					delete_line(gcb, 'T1/2', current_sink.port);
					delete_block(voltage_sink.path);
					delete_block(current_sink.path);
				end
            end
		end % end of if old_m_pop != m_pop
		
	case 'MeasurementLabel'
		hvTag = getSimulinkBlockHandle(strjoin({gcb, 'vTage'}, '/'));
		hiTag = getSimulinkBlockHandle(strjoin({gcb, 'iTage'}, '/'));
		
		% Set voltage tag to new label
		if strcmp(voltage_sink.type, 'label')
			set(hvTag, 'GotoTag', get_param(gcb, 'v_label'));
			set(hvTag, 'TagVisibility', 'global');
		else
			set(hvTag, 'GotoTag', 'Vout');
			set(hvTag, 'TagVisibility', 'local');
		end
		
		% 
		if strcmp(current_sink.type, 'label')
			set(hiTag, 'GotoTag', get_param(gcb, 'c_label'));
			set(hiTag, 'TagVisibility', 'global');
		else
			set(hiTag, 'GotoTag', 'Iout');
			set(hiTag, 'TagVisibility', 'local');
		end

		
	case 'LoopSelector'
		hlTag = getSimulinkBlockHandle(strjoin({gcb, 'loopTag'}, '/'));
		iPort = getSimulinkBlockHandle(strjoin({gcb, 'Iabc'}, '/'));
		if iPort == -1
			iPort = getSimulinkBlockHandle(strjoin({gcb, 'Vabc'}, '/'));
		end
		%  set Loop Tag to new Voltage tag
		if strcmp(get_param(gcb, 'loop_pop'), 'Voltage')
			set(iPort, 'Name', 'Vabc');
			set(hlTag, 'GotoTag', get(getSimulinkBlockHandle(strjoin({gcb, 'vTag'}, '/')), 'GotoTag'));
		else
			set(iPort, 'Name', 'Iabc');
			set(hlTag, 'GotoTag', get(getSimulinkBlockHandle(strjoin({gcb, 'iTag'}, '/')), 'GotoTag'));
		end
		
	case 'DCLinkSelector'


	case 'LCLFilterDesigner'


	case 'LCLFilterCalculator'


	case 'PRColterollerDesigner'


	case default


	end

end