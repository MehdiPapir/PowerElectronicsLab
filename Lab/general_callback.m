function general_callback(scope)
	persistent port old_pop old_label
	if isempty(port)
		port.name = 'output';
		port.path = 0;
		port.port = 0;
		port.source = 0;
		port.handler = 0;
		port.isGlobal = 0;
	end
	if isempty(old_pop)
		old_pop = 'Using Output Port';
	end
	if isempty(old_label)
		old_label = 'A';
	end

	switch scope
	case 'popup'
		mask =Simulink.Mask.get(gcbh);
		label = mask.getParameter('l_name');
		pop = get_param(gcb, 'selector_popup');
		label_val = get_param(gcb, 'l_name');

		% output redefinition
		% port.name = 'output';
		port.path = strjoin({gcb, port.name}, '/');
		port.port = strjoin({port.name, '1'}, '/');
		
		% ally source difinition
		source.name = 'Sine Wave';
		source.path = strjoin({gcb, port.name}, '/');
		source.port = strjoin({source.name, '1'}, '/');
		if ~strcmp(old_pop, pop)
			disp('Popup Callback')
			old_pop = pop;
			switch pop
			case 'Using Output Port'
				% disp('in uop case')
				label.Visible = 'off';
				port.source = 'simulink/Sinks/Out1';
				port.isGlobal = 0;		
				
			case 'Using Global Label'
				% disp('in ugl case')
				label.Visible = 'on';
				port.source = 'simulink/Signal Routing/Goto';
				port.isGlobal = 1;		
			case 'No Output'
				% disp('in no case')
				label.Visible = 'off';
				port.source = 'simulink/Signal Routing/Goto';
				port.isGlobal = 0;		
				
			end % end of pop switch
		end % end of if
		try delete_line(gcb, source.port, port.port);	 		catch disp('old line not deleted');	 end
		try delete_block(port.path);					 		catch disp('old block not deleted'); end
		try port.handler = add_block(port.source, port.path);	catch disp('new block not added');	 end
		try add_line(gcb, source.port, port.port);		 		catch disp('new line not added');	 end
		if port.isGlobal==1
			set(port.handler, 'GotoTag', label_val);
			set(port.handler, 'TagVisibility', 'global');
		end % end of if
	
	case 'unit'
		if port.handler~=0
			label_val = get_param(gcb, 'l_name');
			if (~strcmp(old_label,label_val) & port.isGlobal==1)
				disp('Unit Callback')
				old_label = label_val;
				set(port.handler, 'GotoTag', label_val);
				set(port.handler, 'TagVisibility', 'global');
			end
		else
			disp('port refer to root')
		end
	end % end of scope switch
end % end of function