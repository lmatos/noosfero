var root = new Array();
var links = {};
var index = 0;

var options = {"_blank":"Blank", "_self":"Self", "_popup":"Popup"};

function render_options(selected) {
  var html = ""
  for(var key in options) {
    html += "<option value=\""+key+"\" "+(selected == key ? "selected" : "")+">"+options[key]+"</option>"
  }
  return html;
}

function Link(t) {
  this.index = index++;
  this.icon = null;
  this.title = t;
  this.address = "";
  this.target = "";
  
  this.children = new Array();
  this.parent = null;

  /* attach a this child to a parent*/
  this.attach = function(parent) {
    parent.add(this);
  }
  
  /* detach this child from its parent */
  this.detach = function() {
    if(this.parent != null) {
      this.parent.remove(this);
    }
    else
    {
       delete links[this.index];
       for(var i=0; i<root.size(); i++) {
        if(root[i] == this) {
          root.pop(i);
          break;
        }
       }
    }
  }
  
  /* add a child to a parent */
  this.add = function(link) {
    link.parent = this;
    links[link.index] = link;
    this.children.push(link);

  }
  
  /* remove a child from a parent */
  this.remove = function(link) {
    for(var i=0; i<this.children.size(); i++) {
      if(this.children[i] == link) {
        this.children[i].parent = null;
        delete links[this.children[i].index];
        this.children.pop(i);
        break;
      }
    }
  }
  
  this.render_link = function(parent_prefix,index,depth) {
    var my_prefix = parent_prefix + "[" + index + "]";
    var my_id = my_prefix + "-" + this.index;

    var html = "<li id=\""+my_id+"\">";

    html += "<div class=\"controls\">";
    if(depth < 2) {
      html += "<a class=\"button icon-add with-text\"href=\"#\" onclick='add_sub_item("+this.index+")'>Adicionar link</a>";
    }
    html += "<a class=\"button icon-delete with-text\"href=\"#\" onclick='remove_link("+this.index+")'>Remover</a>";

    html += "</div> <br>";

    html += "<input name="+my_prefix+"['icon'] id='block_root__icon' value=\""+this.icon+"\" type=\"hidden\" class=\"icon-input\">";    
    html += "<span class=\""+this.icon+"\" style=\"display:block; width:16px; height:16px;\" onclick='show_icons(this)'></span>";
    html += "<div class='icon-selector' style='display:none' onclick=\"store_icon('"+my_id+"',"+this.index+");\">"+jQuery("#display-icons .icon-selector").html()+"</div>";
    html += "<input name="+my_prefix+"['title'] value=\""+this.title+"\" type=\"text\" class=\"\" onkeyup=\"store(this,"+this.index+",'title');\">";
    html += "<input name="+my_prefix+"['address'] value=\""+this.address+"\" type=\"text\" class=\"\" onkeyup=\"store(this,"+this.index+",'address');\">";
    html += "<select name="+my_prefix+"['target'] type=\"text\" class=\"\" onchange=\"store(this,"+this.index+",'target');\">";
    html += render_options(this.target);
    html += "</select>";
    

    
    if(this.children.size() > 0) {
      html += this.render_children(my_prefix, depth+1);
    }
    
    html += "</li>";
    return html;
  }
  
  this.render_children = function(prefix, depth) {
    var html = "<ul>";
    for(var i=0; i<this.children.size(); i++) {
      html += this.children[i].render_link(prefix, i, depth);
    }
    html += "</ul>";
    return html;
  }
  
}

function update_preview() {
  html = "<ul>";
  
  for(var i=0 ; i<root.length ; i++) {
    html += root[i].render_link('links',i,0);
  }
  
  html += "</ul>";
  
  jQuery("#preview-tree").html(html);
  
  return false;
}

function add_root() {
  var link = new Link('New Link');
  root.push(link);
  links[link.index] = link;
  update_preview();
}

function add_sub_item(idx) {
  links[idx].add(new Link('New Link'));
  update_preview();
}

function remove_link(idx) {
  links[idx].detach();
  update_preview();
}

function show_icons(tag) {
  var icons_box = jQuery(tag).parent().children(".icon-selector");
  icons_box.show();
}

function store(tag,index,field) {
  links[index][field] = tag.value;
}

function store_icon(tag,index) {

  icon = "icon-"+document.getElementById(tag).children[2].value;
  console.log(icon);
  links[index]['icon'] = icon;
}

