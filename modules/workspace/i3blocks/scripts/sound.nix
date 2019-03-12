{ pamixer, iconfont, ... }:
''
code=0
if [[ `${pamixer}/bin/pamixer --get-mute` = "true" ]]
then
  volume=""
  end=""
  icon=""
else
  volume=`${pamixer}/bin/pamixer --get-volume`
  end="%"
  if [[ $volume -lt 33 ]]
  then
    icon=""
  else
    if [[ $volume -lt 66 ]]
    then
      icon=""
    else
      icon=""
      code=33
    fi
  fi
fi
echo "<span font='${iconfont}'>$icon</span> $volume$end"
exit $code
''
