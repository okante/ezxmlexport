<table class="list-thumbnails" cellspacing="0">
  <tr>
    {def $checkedIDArray = array()}
    {section var=Nodes loop=$node_array sequence=array( bglight, bgdark )}
    {* Note: The tpl code for $ignore_nodes_merge with the eq, unique and count
             is just a replacement for a missing template operator.
             If there are common elements the unique array will have less elements
             than the merged one
             In the future this should be replaced with a  new template operator that checks
             one array against another and returns true if elements in the first
             exists in the other *}
    {let child_name=$Nodes.item.name|wash
         ignore_nodes_merge_click=merge( $browse.ignore_nodes_click, $Nodes.item.path_array )
         ShowLink=and( eq( $ignore_nodes_merge_click|count,
                            $ignore_nodes_merge_click|unique|count ),
                       or( ne( $browse.action_name, 'MoveNode' ), ne( $browse.action_name, 'CopyNode' ) ),
                       $Nodes.item.object.content_class.is_container ) }
        <td width="25%">
        {* $ShowLink is passed in node_view_gui for corresponding representation of image. *}
        {node_view_gui view=browse_thumbnail content_node=$Nodes.item show_link=$ShowLink}
        <div class="controls">
        {* Checkboxes *}
        {* Note: The tpl code for $ignore_nodes_merge with the eq, unique and count
                 is just a replacement for a missing template operator.
                 If there are common elements the unique array will have less elements
                 than the merged one
                 In the future this should be replaced with a  new template operator that checks
                 one array against another and returns true if elements in the first
                 exists in the other *}

        {let ignore_nodes_merge=merge( $browse.ignore_nodes_select_subtree, $Nodes.item.path_array )}
        {section show=and( or( $browse.permission|not,
                           cond( is_set( $browse.permission.contentclass_id ),
                                 fetch( content, access, hash( access,          $browse.permission.access,
                                                               contentobject,   $Nodes.item,
                                                               contentclass_id, cond( $browse.permission.contentclass_id|is_array(), $browse.permission.contentclass_id.0, $browse.permission.contentclass_id ) ) ),
                                 fetch( content, access, hash( access,          $browse.permission.access,
                                                               contentobject,   $Nodes.item ) ) ) ),
                           eq( $ignore_nodes_merge|count,
                               $ignore_nodes_merge|unique|count ) )}
            {section show=is_array( $browse.class_array )}
                {section show=$browse.class_array|contains( $Nodes.item.object.content_class.identifier )}
                    <input type="{$select_type}" name="{$select_name}[]" value="{$Nodes.item[$select_attribute]}" />
                {section-else}
                    <input type="{$select_type}" name="" value="" disabled="disabled" />
                {/section}
            {section-else}
                {section show=and( or( eq( $browse.action_name, 'MoveNode' ), eq( $browse.action_name, 'CopyNode' ) ), $Nodes.item.object.content_class.is_container|not )}
                    <input type="{$select_type}" name="{$select_name}[]" value="{$Nodes.item[$select_attribute]}" disabled="disabled" />
                {section-else}
                    {if and( is_set( $browse.persistent_data.ExportSources ), 
                            count( $browse.persistent_data.ExportSources )|gt( 0 ),
                            $browse.persistent_data.ExportSources|contains( $Nodes.item[$select_attribute] ) )}
                        <input type="{$select_type}" name="{$select_name}[]" value="{$Nodes.item[$select_attribute]}" checked="checked"/>
                        {set $checkedIDArray = $checkedIDArray|append( $Nodes.item[$select_attribute] )}
                    {else}
                        <input type="{$select_type}" name="{$select_name}[]" value="{$Nodes.item[$select_attribute]}" />
                    {/if}
                {/section}
            {/section}
        {section-else}
            <input type="{$select_type}" name="" value="" disabled="disabled" />
        {/section}
        {/let}

        <p>{section show=$ShowLink}
            <a href={concat( '/content/browse/', $Nodes.item.node_id )|ezurl}>{$Nodes.item.name|wash}</a>
        {section-else}
            {$Nodes.item.name|wash}
        {/section}</p>
        </div>
        </td>
    {/let}
    {delimiter modulo=4}
    </tr><tr>
    {/delimiter}
    {/section}
  </tr>
</table>
{if is_set( $browse.persistent_data.ExportSources )}
    {foreach $browse.persistent_data.ExportSources as $export_source_id}
        {if $checkedIDArray|contains( $export_source_id )|not}
            <input type="hidden" name="{$select_name}[]" value="{$export_source_id}"/>
        {/if}
    {/foreach}
{/if}
