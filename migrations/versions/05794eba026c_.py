"""empty message

Revision ID: 05794eba026c
Revises: 8be18de84c21
Create Date: 2016-10-12 11:59:02.005225

"""

# revision identifiers, used by Alembic.
revision = '05794eba026c'
down_revision = '8be18de84c21'

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_table('choices',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(length=64), nullable=False),
    sa.Column('detail', sa.Text(), nullable=False),
    sa.Column('c_type', sa.Boolean(), nullable=False),
    sa.Column('answer', sa.String(length=64), nullable=False),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('programs',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('title', sa.String(length=64), nullable=False),
    sa.Column('detail', sa.Text(), nullable=False),
    sa.Column('difficulty', sa.Integer(), nullable=True),
    sa.Column('acceptedNum', sa.Integer(), nullable=True),
    sa.Column('submitNum', sa.Integer(), nullable=True),
    sa.Column('createdTime', sa.DateTime(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.drop_table('problems')
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_table('problems',
    sa.Column('id', mysql.INTEGER(display_width=11), nullable=False),
    sa.Column('title', mysql.VARCHAR(length=64), nullable=False),
    sa.Column('detail', mysql.TEXT(), nullable=False),
    sa.Column('difficulty', mysql.INTEGER(display_width=11), autoincrement=False, nullable=True),
    sa.Column('acceptedNum', mysql.INTEGER(display_width=11), autoincrement=False, nullable=True),
    sa.Column('submitNum', mysql.INTEGER(display_width=11), autoincrement=False, nullable=True),
    sa.Column('createdTime', mysql.DATETIME(), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    mysql_default_charset=u'utf8',
    mysql_engine=u'InnoDB'
    )
    op.drop_table('programs')
    op.drop_table('choices')
    ### end Alembic commands ###