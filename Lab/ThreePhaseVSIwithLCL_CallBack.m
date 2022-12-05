function ThreePhaseVSIwithLCL_CallBack(scope)
%Three Phase VSI with LCL General CallBack - Description
%
% Syntax: ThreePhaseVSIwithLCL_CallBack(scope)
%
% Long description
	persistent old_dc_pop old_loop_pop old_m_pop old_m_label
	persistent signal_source signal_sink
	if isempty(old_dc_pop)
		old_dc_pop = 'Internal';
	end
	if isempty(old_loop_pop)
		old_loop_pop = 'Current';
	end
	if isempty(old_m_pop)
		old_m_pop = 'Yes, with Port';
	end
	if isempty(old_m_label)
		old_m_label = 'Mi';
	end
	if isempty(signal_sink)
		signal_source.name = 'BusCreator';
		signal_source.port = strjoin({signal_source.name, '1'}, '/');
		signal_source.path = strjoin({gcb, signal_source.name}, '/');
		signal_source.source = 0;
		signal_source.global = 'off';
		signal_source.handler = 0;

		signal_sink.name = 'M';
		signal_sink.port = strjoin({signal_sink.name, '1'}, '/');
		signal_sink.path = strjoin({gcb, signal_sink.name}, '/');
		signal_sink.source = 0;
		signal_sink.global = 'off';
		signal_sink.handler = 0;
	end

	switch scope
	case 'MeasurementPopup'
		mask = Simulink.Mask.get(gcbh);
		m_pop = get_param(gcb, 'm_pop');
		label = mask.getParameter('m_label');

		if ~strcmp(old_m_pop, m_pop)
			old_m_pop = m_pop;

			switch m_pop
            case 'Yes, with Port'
                label.Visible = 'off';
                signal_sink.global = 'off';
                signal_sink.source = 'simulink/Sinks/Out1';

            case 'Yes, with Label'
                label.Visible = 'on';
                signal_sink.global = 'on';
                signal_sink.source = 'simulink/Signal Routing/Goto';

            case 'No Measure'
                label.Visible = 'off';
                signal_sink.global = 'off';
                signal_sink.source = 'simulink/Signal Routing/Goto';
            end
            
			try	delete_line(gcb, signal_source.port , signal_sink.port);				 catch; disp('dl'); end
			try	delete_block(signal_sink.path);											 catch; disp('db'); end
			try	signal_sink.handler = add_block(signal_sink.source, signal_sink.path);	 catch; disp('ab'); end
			try	add_line(gcb, signal_source.port, signal_sink.port);					 catch; disp('al'); end
			if strcmp(signal_sink.global, 'on')
				set(signal_sink.handler, 'GotoTag', get_param(gcb, 'm_label'));
				set(signal_sink.handler, 'TagVisibility', 'global');
			end
		end % end of if old_m_pop != m_pop

	case 'MeasurementLabel'


	case 'DCLinkSelector'


	case 'LoopSelector'


	case 'LCLFilterDesigner'


	case 'LCLFilterCalculator'


	case 'PRColterollerDesigner'


	case default


	end

end