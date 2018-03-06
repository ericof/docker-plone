from prettyconf import config
import transaction

ADMIN_USER = config('ADMIN_USER', default='admin')
ADMIN_PASSWD = config('ADMIN_PASSWD', default='admin')

app.acl_users._doAddUser(ADMIN_USER, ADMIN_PASSWD, ['Manager'], [])
transaction.commit()
