#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
#    Copyright (C) 2010  Dr. Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  # FIXME: 
  #   need to manually patch $RVM/gems/rsruby-0.5.1.1/ext/rsruby.c (see http://rubyforge.org/forum/forum.php?thread_id=46998&forum_id=7794) as follows:
  #   
  # --- rsruby.c	2010-12-23 17:45:03.000000000 +0000
  # +++ /tmp/rsruby.c	2010-12-23 17:44:46.000000000 +0000
  # @@ -30,6 +30,18 @@
  #  */
  # 
  #  #include "rsruby.h"
  # +#include <sys/time.h>
  # +#include <sys/resource.h>
  # +#define STACK_MULTIPLIER 16
  # +
  # +void increase_stack_size(void)
  # +{
  # +struct rlimit rlim;
  # +
  # +getrlimit(RLIMIT_STACK, &rlim);
  # +rlim.rlim_cur = rlim.rlim_cur * STACK_MULTIPLIER;
  # +setrlimit(RLIMIT_STACK, &rlim);
  # +}
  # 
  #  /* Global list to protect R objects from garbage collection */
  #  /* This is inspired in $R_SRC/src/main/memory.c */
  # @@ -130,6 +142,7 @@
  # 
  #    SEXP R_References;
  # 
  # +  increase_stack_size();
  #    init_R(0,NULL);
  #    // Initialize the list of protected objects
  #    R_References = R_NilValue;
  
  #def initialize
  #  @r = RSRuby.instance
  #end
end
