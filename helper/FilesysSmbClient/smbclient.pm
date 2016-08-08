# This file was automatically generated by SWIG (http://www.swig.org).
# Version 3.0.8
#
# Do not make changes to this file unless you know what you are doing--modify
# the SWIG interface file instead.

package smbclient;
use base qw(Exporter);
use base qw(DynaLoader);
package smbclientc;
bootstrap smbclient;
package smbclient;
@EXPORT = qw();

# ---------- BASE METHODS -------------

package smbclient;

sub TIEHASH {
    my ($classname,$obj) = @_;
    return bless $obj, $classname;
}

sub CLEAR { }

sub FIRSTKEY { }

sub NEXTKEY { }

sub FETCH {
    my ($self,$field) = @_;
    my $member_func = "swig_${field}_get";
    $self->$member_func();
}

sub STORE {
    my ($self,$field,$newval) = @_;
    my $member_func = "swig_${field}_set";
    $self->$member_func($newval);
}

sub this {
    my $ptr = shift;
    return tied(%$ptr);
}


# ------- FUNCTION WRAPPERS --------

package smbclient;

*smbc_new_context = *smbclientc::smbc_new_context;
*smbc_free_context = *smbclientc::smbc_free_context;
*smbc_getDebug = *smbclientc::smbc_getDebug;
*smbc_setDebug = *smbclientc::smbc_setDebug;
*smbc_getTimeout = *smbclientc::smbc_getTimeout;
*smbc_setTimeout = *smbclientc::smbc_setTimeout;
*smbc_getOptionDebugToStderr = *smbclientc::smbc_getOptionDebugToStderr;
*smbc_setOptionDebugToStderr = *smbclientc::smbc_setOptionDebugToStderr;
*smbc_getOptionUserData = *smbclientc::smbc_getOptionUserData;
*smbc_setOptionUserData = *smbclientc::smbc_setOptionUserData;
*smbc_getOptionUseKerberos = *smbclientc::smbc_getOptionUseKerberos;
*smbc_setOptionUseKerberos = *smbclientc::smbc_setOptionUseKerberos;
*smbc_getOptionFallbackAfterKerberos = *smbclientc::smbc_getOptionFallbackAfterKerberos;
*smbc_setOptionFallbackAfterKerberos = *smbclientc::smbc_setOptionFallbackAfterKerberos;
*smbc_getOptionNoAutoAnonymousLogin = *smbclientc::smbc_getOptionNoAutoAnonymousLogin;
*smbc_setOptionNoAutoAnonymousLogin = *smbclientc::smbc_setOptionNoAutoAnonymousLogin;
*smbc_getOptionUseCCache = *smbclientc::smbc_getOptionUseCCache;
*smbc_setOptionUseCCache = *smbclientc::smbc_setOptionUseCCache;
*smbc_getFunctionAuthDataWithContext = *smbclientc::smbc_getFunctionAuthDataWithContext;
*smbc_setFunctionAuthDataWithContext = *smbclientc::smbc_setFunctionAuthDataWithContext;
*smbc_init_context = *smbclientc::smbc_init_context;
*smbc_set_context = *smbclientc::smbc_set_context;
*smbc_open = *smbclientc::smbc_open;
*smbc_lseek = *smbclientc::smbc_lseek;
*smbc_close = *smbclientc::smbc_close;
*smbc_unlink = *smbclientc::smbc_unlink;
*smbc_rename = *smbclientc::smbc_rename;
*smbc_opendir = *smbclientc::smbc_opendir;
*smbc_closedir = *smbclientc::smbc_closedir;
*smbc_readdir = *smbclientc::smbc_readdir;
*smbc_mkdir = *smbclientc::smbc_mkdir;
*smbc_rmdir = *smbclientc::smbc_rmdir;
*smbc_stat = *smbclientc::smbc_stat;
*smbc_fstat = *smbclientc::smbc_fstat;
*w_stat2str = *smbclientc::w_stat2str;
*w_debug = *smbclientc::w_debug;
*w_get_auth_data_with_context = *smbclientc::w_get_auth_data_with_context;
*w_initAuth = *smbclientc::w_initAuth;
*w_smbc_dirent_name_get = *smbclientc::w_smbc_dirent_name_get;
*w_smbc_write = *smbclientc::w_smbc_write;
*w_smbc_read = *smbclientc::w_smbc_read;
*w_create_struct_stat = *smbclientc::w_create_struct_stat;
*w_free_struct_stat = *smbclientc::w_free_struct_stat;

############# Class : smbclient::smbc_dirent ##############

package smbclient::smbc_dirent;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( smbclient );
%OWNER = ();
%ITERATORS = ();
*swig_smbc_type_get = *smbclientc::smbc_dirent_smbc_type_get;
*swig_smbc_type_set = *smbclientc::smbc_dirent_smbc_type_set;
*swig_dirlen_get = *smbclientc::smbc_dirent_dirlen_get;
*swig_dirlen_set = *smbclientc::smbc_dirent_dirlen_set;
*swig_commentlen_get = *smbclientc::smbc_dirent_commentlen_get;
*swig_commentlen_set = *smbclientc::smbc_dirent_commentlen_set;
*swig_comment_get = *smbclientc::smbc_dirent_comment_get;
*swig_comment_set = *smbclientc::smbc_dirent_comment_set;
*swig_namelen_get = *smbclientc::smbc_dirent_namelen_get;
*swig_namelen_set = *smbclientc::smbc_dirent_namelen_set;
*swig_name_get = *smbclientc::smbc_dirent_name_get;
*swig_name_set = *smbclientc::smbc_dirent_name_set;
sub new {
    my $pkg = shift;
    my $self = smbclientc::new_smbc_dirent(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        smbclientc::delete_smbc_dirent($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


############# Class : smbclient::w_userdata ##############

package smbclient::w_userdata;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( smbclient );
%OWNER = ();
%ITERATORS = ();
*swig_username_get = *smbclientc::w_userdata_username_get;
*swig_username_set = *smbclientc::w_userdata_username_set;
*swig_password_get = *smbclientc::w_userdata_password_get;
*swig_password_set = *smbclientc::w_userdata_password_set;
*swig_workgroup_get = *smbclientc::w_userdata_workgroup_get;
*swig_workgroup_set = *smbclientc::w_userdata_workgroup_set;
sub new {
    my $pkg = shift;
    my $self = smbclientc::new_w_userdata(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        smbclientc::delete_w_userdata($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


############# Class : smbclient::w_smbc_read_result ##############

package smbclient::w_smbc_read_result;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( smbclient );
%OWNER = ();
%ITERATORS = ();
*swig_ret_get = *smbclientc::w_smbc_read_result_ret_get;
*swig_ret_set = *smbclientc::w_smbc_read_result_ret_set;
*swig_buf_get = *smbclientc::w_smbc_read_result_buf_get;
*swig_buf_set = *smbclientc::w_smbc_read_result_buf_set;
sub new {
    my $pkg = shift;
    my $self = smbclientc::new_w_smbc_read_result(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        smbclientc::delete_w_smbc_read_result($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


# ------- VARIABLE STUBS --------

package smbclient;

*SMB_CTX_FLAG_USE_KERBEROS = *smbclientc::SMB_CTX_FLAG_USE_KERBEROS;
*SMB_CTX_FLAG_FALLBACK_AFTER_KERBEROS = *smbclientc::SMB_CTX_FLAG_FALLBACK_AFTER_KERBEROS;
*SMBCCTX_FLAG_NO_AUTO_ANONYMOUS_LOGON = *smbclientc::SMBCCTX_FLAG_NO_AUTO_ANONYMOUS_LOGON;
*SMB_CTX_FLAG_USE_CCACHE = *smbclientc::SMB_CTX_FLAG_USE_CCACHE;
*SMBC_WORKGROUP = *smbclientc::SMBC_WORKGROUP;
*SMBC_SERVER = *smbclientc::SMBC_SERVER;
*SMBC_FILE_SHARE = *smbclientc::SMBC_FILE_SHARE;
*SMBC_PRINTER_SHARE = *smbclientc::SMBC_PRINTER_SHARE;
*SMBC_COMMS_SHARE = *smbclientc::SMBC_COMMS_SHARE;
*SMBC_IPC_SHARE = *smbclientc::SMBC_IPC_SHARE;
*SMBC_DIR = *smbclientc::SMBC_DIR;
*SMBC_FILE = *smbclientc::SMBC_FILE;
*SMBC_LINK = *smbclientc::SMBC_LINK;
*W_USERDATA_BUFLEN = *smbclientc::W_USERDATA_BUFLEN;
1;
