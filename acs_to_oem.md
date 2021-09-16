---
title: OeM Converter
permalink: /oemconverter/
---

## This is experimental.
This should work reasonably well, but not every feature is supported yet.

Enter the text into the input field and it will automatically attempt to convert.
Let me know if there's an issue.


<script type="text/javascript" src="https://unpkg.com/jquery@3.6.0/dist/jquery.js"></script>
<script type="text/javascript">
function convert_code() {
  acs_code = $('#beep').val().replace(/\\\n/g, '');
  oem_code = '';

  var in_block = 0;
  var in_rule = 0;

  function prefix() {
    let ret = '';
    for (let i = 0; i < in_block; i++) ret += '  ';
    return ret;
  }

  function prefixify(func) {
    return function(n) {
      return prefix() + func(n);
    }
  }

  function dec_block() {
    in_block--;
    oem_code += prefix() + 'end\n';
  }

  var regexes = [
    / +/,
    /"([^"]|\""]*)"/,
    /\n *\n/,
    /\n/,
    /#.*/,
    /mode +([A-Za-z]*) +\((.*)\)(.*)/,
    /action *\(([a-zA-Z0-9]*) *= *([a-zA-Z0-9]*)\)\.\.\./,
    /rule *\(([a-zA-Z0-9]*) *= *([a-zA-Z0-9]*)\)\.\.\. *\n/,
    new RegExp(` *(say${$('#acs_renamer_set').val()}) (.*)`),
    new RegExp(` *(say${$('#acs_renamer_say').val()}) (.*)`),
    new RegExp(` *(say${$('#acs_color').val()}) (.*)`),
    / *([^:\n]*?):(.*)/,
  ];
  var rebuilds = [
    n => '',
    n => n[0],
    function(n) {
      if (in_block > 0) {
        in_block--;
        return '\nend\n\n';
      } else return '\n\n'
    },
    n => n[0],
    n => "// " + n[0].substring(1),
    function(n) {
      var ret = `button ${n[1]}\n`;
      for (let button of n[2].matchAll(/ *([a-zA-Z0-9_ ]*) *= *\d[^;]*;/g)) {
        ret += `    option \"${button[1]}\"\n`;
      }
      ret += "end\n";

      return ret;
    },
    function(n) {
      var ret = `on ${n[1]} = "${n[2]}"`;
      in_block++;
      return ret;
    },
    function(n) {
      var ret = `when ${n[1]} = "${n[2]}"\n`;
      if ( in_block ) dec_block();
      
      in_block++;
      in_rule = 1;
      return ret;
    },
    prefixify(n => `set wearer_name=${n[2]}${prefix()}set manufacturer=`),
    prefixify(n => `say ${n[2]}`),
    prefixify(n => `set color=${n[2]}`),
    prefixify(function(n) {
      switch (n[1]) {
        case "self":
          return `think "${n[2]}"`;
        case "say":
          return `${n[1]} "${n[2]}"`;
        case "wait":
          return `wait ${n[2]}`;
        case "speechname":
          return `set wearer_name=${n[2]}`;
        default:
          console.log(n);
          return `#Unknown: ${n[0]}`
      }
    }),
  ];
  console.log( regexes );

  while (acs_code != '') {
    if (in_rule) {
      line = acs_code.match(/.*\n/)[0];
      if (line.trim() == '') {
        oem_code += 'end\n';
        in_block--;
        in_rule = 0;
      } else {
        acs_code = acs_code.substring(line.length);
        oem_code += `  rule "${line.trim()}"\n`
        continue;
      }
    }

    earliest_match = -1;
    earliest_index = -1;
    for (var i in regexes) {
      match = acs_code.match(regexes[i]);
      if (match != null && (earliest_index == -1 || earliest_match.index > match.index)) {
        earliest_index = i;
        earliest_match = match;
      }
    }

    if (earliest_index >= 0 && earliest_match.index != 0) {
      oem_code += '\n### UNHANDLED ###\n' + acs_code.substring(0, earliest_match.index);
      acs_code = '';
    }
    if (earliest_index == -1) {
      oem_code += '\n### UNFOUND ###\n' + acs_code;
      acs_code = '';
    } else {
      let new_text = rebuilds[earliest_index](earliest_match);
      oem_code += /*`[[${earliest_index}]]` +*/ new_text;
      acs_code = acs_code.substring(earliest_match[0].length);
    }
  }

  while (in_block > 0) {
    dec_block();
  }

  $('#boop').text(oem_code);
}
console.log($);
$(function() {
    $('#beep').change(convert_code);
    convert_code();
});
</script>


<ul>
    <li>I use a renamer with ACS, and the name can be changed with the following command: <input type="text" id="acs_renamer_set" value=">:9,jarename" /></li>
    <li>I use a renamer with ACS, and it can relay with: <input type="text" id="acs_renamer_say" value=">:9,jarelay" /></li>
    <li>I use a color system with ACS, configurable with the following ACS command: <input type="text" id="acs_color" value=">:9,jacolor" /></li>
</ul>
<textarea style="width: 100%;height: 30em;" id="beep">
</textarea>
<input type="button" click="convert_code" value="Convert" />

<h2>
Converted script:
</h2>
<pre id="boop"></pre>
