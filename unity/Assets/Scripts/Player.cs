using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

    private Transform transformOrig;

	private void Start () {
        transformOrig = transform;
	}

    public void reset() {
        transform.position = transformOrig.position;
        transform.rotation = transformOrig.rotation;
        transform.localScale = transformOrig.localScale;
    }

}
