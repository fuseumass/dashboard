// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

function changeSliderOutput(output_id, desc_id, slider_id, scores){
    output_id.value = slider_id.value
    desc_id.value = scores.find(o => o['points'] >= slider_id.value)['description']
}

var mass_entries = []

function create_entry(judge_id, project_id, tag_id, form_id, list_name ) {
    if (judge_id.value === "" || project_id.value === "") {
        return 
    }

    if (mass_entries.find(x => x[0] === judge_id.value && x[1] == project_id.value && x[2] === tag_id.value) == null) {
        mass_entries.push([judge_id.value, project_id.value, tag_id.value])
    }

    form_id.reset()
    update_entries(list_name)
}

function update_entries(list_name) {

    let listhtml = ""
    for ( let [judge_name, project_name, tag_name] of mass_entries ) {
        listhtml += `
            <div class="row">
            <input name="entry[][judge_email]" value="${judge_name}" type="hidden" multiple />
            <input name="entry[][project_name]" value="${project_name}" type="hidden" multiple />
            <input name="entry[][tag_name]" value="${tag_name}" type="hidden" multiple />
            <div class="col-md-12">
                <div class="card my-1">
                    <div class="card-body py-2">
                        <div class="form-row pt-1">
                            <div class="form-group col-md-4 pt-2">
                                <h5 class="d-inline"> Judge: </h5> ${judge_name}
                            </div>
                            <div class="form-group col-md-4 pt-2">
                                <h5 class="d-inline"> Project Name: </h5>${project_name}
                            </div>
                            <div class="form-group col-md-3 pt-2">
                                <h5 class="d-inline"> Tag: </h5>${tag_name}
                            </div>
                            <div class="form-group col-md-1">
                                <button type="button" class="btn btn-danger" onclick="remove_entry('${judge_name}', '${project_name}', '${tag_name}', '${list_name}')"> remove </button> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </div>
        `


    }


    document.getElementById(list_name).innerHTML = listhtml
}

function remove_entry(judge_name, project_name, tag_name, list_name) {
    let ind = mass_entries.indexOf(mass_entries.find(x => x[0] === judge_name && x[1] == project_name && x[2] === tag_name))
    mass_entries.splice(ind, 1)
    update_entries(list_name)
}

function clear_entries(list_name) {
    mass_entries = []
    update_entries(list_name)
}