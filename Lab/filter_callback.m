function filter_callback()
%#ok<*ST2NM>
%#ok<*NBRAK>
  feedback = get_param(gcb, 'feedback_filter');
  mask = Simulink.Mask.get(gcb);
  cf = mask.getParameter('cutoff_freq');
  fo = mask.getParameter('filter_order');

  cf.Visible = feedback;
  fo.Visible = feedback;

  if strcmp(feedback, 'on')
    order = str2num(get_param(gcb, 'filter_order'));
    cutoff= str2num(get_param(gcb, 'cutoff_freq'));

    den = [1];
    for n=1:order
      den = conv(den, [1 cutoff]);
    end

    filter = @(s) ( (cutoff) / (s + cutoff) )^order;
    amp = abs( filter(1i*cutoff) );
    gain = 1 / amp;
    g2 = gain * 20 / 1.27;
    disp([gain amp g2])
    num = (cutoff ^ order) * g2;
  else
    num = [1]; 
    den = [1];
  end
  set_param(gcb, 'filter_num', strjoin({'[', num2str(num), ']'}, ''));
  set_param(gcb, 'filter_den', strjoin({'[', num2str(den), ']'}, ''));
end
