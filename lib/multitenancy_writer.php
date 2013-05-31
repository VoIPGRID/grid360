<?php

class Multitenancy_QueryWriter_MySQL extends RedBean_QueryWriter_MySQL
{
    private $non_tenant_types = array('userlevel', 'rating');

    public function selectRecord($type, $conditions, $addSql = null, $delete = null, $inverse = false, $all = false)
    {
        if(!in_array($type, $this->non_tenant_types))
        {
            if(isset($_SESSION['current_user']))
            {
                $conditions['tenant_id'] = $_SESSION['current_user']->tenant_id;
            }
        }

        return parent::selectRecord($type, $conditions, $addSql, $delete, $inverse, $all);
    }

    public function insertRecord($table, $insertcolumns, $insertvalues)
    {
        if(isset($_SESSION['current_user']))
        {
            $insertcolumns[] = 'tenant_id';
            $insertvalues[0][] = $_SESSION['current_user']->tenant_id;
        }

        return parent::insertRecord($table, $insertcolumns, $insertvalues);
    }
}
