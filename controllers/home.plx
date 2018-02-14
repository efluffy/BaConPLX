sub default {
  %view_data = (id => 1, name => 'test name');
  $title = 'test page';
  load_view('home', %view_data);
}

return true;
