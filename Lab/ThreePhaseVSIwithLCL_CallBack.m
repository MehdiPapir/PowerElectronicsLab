function ThreePhaseVSIwithLCL_CallBack(scope)
%Three Phase VSI with LCL General CallBack - Description
%
% Syntax: ThreePhaseVSIwithLCL_CallBack(scope)
%
% Long description
	persistent old_selector old_loop_pop old_m_pop old_v_label old_c_label
	persistent voltage_sink current_sink pos_dc_port neg_dc_port
	if isempty(old_selector)
		old_selector = 'Internal';
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
	if isempty(pos_dc_port)
		pos_dc_port.name = '+';
		pos_dc_port.path = strjoin({gcb, pos_dc_port.name}, '/');
		pos_dc_port.port = 'WarZone/Inverter/+/1';
		pos_dc_port.source = 'powerlib/Elements/Connection Port';
		pos_dc_port.handler = -1;
		pos_dc_port.position = [65, 213, 95, 227];
		pos_dc_port.linkPoints = [99, 220; 140, 220];
		pos_dc_port.linkHandler = -1;
		
		neg_dc_port.name = '-';
		neg_dc_port.path = strjoin({gcb, neg_dc_port.name}, '/');
		% neg_dc_port.path = 'WarZone/Inverter/-';
		neg_dc_port.source = 'powerlib/Elements/Connection Port';
		neg_dc_port.handler = -1;
		neg_dc_port.position = [65, 273, 95, 287];
		neg_dc_port.linkPoints = [99, 280; 140, 280];
		neg_dc_port.linkHandler = -1;
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
                current_sink.type = 'port';
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
                current_sink.type = 'label';
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
                current_sink.type = 'none';
				try
					delete_line(gcb, 'T1/1', voltage_sink.port);
					delete_line(gcb, 'T1/2', current_sink.port);
					delete_block(voltage_sink.path);
					delete_block(current_sink.path);
				end
            end
		end % end of if old_m_pop != m_pop
		
	case 'MeasurementLabel'
		hvTag = getSimulinkBlockHandle(strjoin({gcb, 'vTag'}, '/'));
		hiTag = getSimulinkBlockHandle(strjoin({gcb, 'iTag'}, '/'));
		
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
		selector = get_param(gcb, 'dc_pop');
		hDCS = getSimulinkBlockHandle(strjoin({gcb, 'DC Source'}, '/'));
		if ~strcmp(old_selector, selector)
			old_selector = selector;
			if strcmp(selector, 'Internal')
				try delete_line(gcb, pos_dc_port.linkPoints); end
				try delete_line(gcb, neg_dc_port.linkPoints); end
				try delete_block(pos_dc_port.path);			  end
				try delete_block(neg_dc_port.path);			  end
				set(hDCS, 'Commented', 'off');
			else
				try pos_dc_port.handler = add_block(pos_dc_port.source, ...
					pos_dc_port.path, 'Position', pos_dc_port.position);
				end
				try neg_dc_port.handler = add_block(neg_dc_port.source, ...
					neg_dc_port.path, 'Position', neg_dc_port.position);
				end
				try pos_dc_port.linkHandler = add_line(gcb, pos_dc_port.linkPoints); end
				try neg_dc_port.linkHandler = add_line(gcb, neg_dc_port.linkPoints); end
				set(hDCS, 'Commented', 'on');
			end
		end

	case 'LCLFilterDesigner'


	case 'LCLFilterCalculator'


	case 'PRColterollerDesigner'


	case default


	end

end