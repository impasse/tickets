# tickets

train tickets query via cli

## Install

```
git clone https://github.com/lingmm/tickets.git
cd tickets
bundle install
```

## Run

```
~ ruby main.rb
Train tickets query via cli.
Usage:
main.rb [options] [update] <from> <to> [<date>]
Arguments:
update           更新数据
from             出发站
to               到达站
date             查询日期<YYYY-MM-DD>,默认当日
Options:
-h, --help                       显示帮助菜单
-d                               动车
-g                               高铁
-k                               快速
-t                               特快
-z                               直达
```

*tested on archlinux & windows(mingw32-cruby)*
