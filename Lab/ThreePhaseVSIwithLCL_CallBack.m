function ThreePhaseVSIwithLCL_CallBack(scope)
%Three Phase VSI with LCL General CallBack - Description
%
% Syntax: ThreePhaseVSIwithLCL_CallBack(scope)
%
% Long description
	persistent old_dc_pop old_loop_pop old_m_pop old_m_label
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

	
end